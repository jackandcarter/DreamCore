"""Lightweight subset of the Pydantic API used for tests."""
from __future__ import annotations

from dataclasses import dataclass
from datetime import date, datetime
from typing import (
    Any,
    Callable,
    Dict,
    Iterable,
    List,
    Mapping,
    Optional,
    Sequence,
    Tuple,
    Type,
    TypeVar,
    Union,
    get_args,
    get_origin,
    Literal,
)

__all__ = [
    "BaseModel",
    "Field",
    "ValidationError",
    "model_validator",
    "validator",
]


_T = TypeVar("_T")


class ValidationError(Exception):
    """Simplified validation error."""

    def __init__(self, errors: Iterable[str], model: Type[Any]):
        self.errors = list(errors)
        self.model = model
        message = "; ".join(self.errors) or f"Validation error for {model.__name__}"
        super().__init__(message)


_MISSING = object()


@dataclass
class FieldInfo:
    default: Any = _MISSING
    default_factory: Optional[Callable[[], Any]] = None
    description: Optional[str] = None
    ge: Optional[float] = None
    le: Optional[float] = None
    min_length: Optional[int] = None
    max_length: Optional[int] = None

    @property
    def required(self) -> bool:
        return self.default is _MISSING and self.default_factory is None


def Field(
    default: Any = _MISSING,
    *,
    default_factory: Optional[Callable[[], Any]] = None,
    description: Optional[str] = None,
    ge: Optional[float] = None,
    le: Optional[float] = None,
    min_length: Optional[int] = None,
    max_length: Optional[int] = None,
) -> FieldInfo:
    if default is ...:
        default = _MISSING
    if default is not _MISSING and default_factory is not None:
        raise ValueError("Field cannot specify both default and default_factory")
    return FieldInfo(
        default=default,
        default_factory=default_factory,
        description=description,
        ge=ge,
        le=le,
        min_length=min_length,
        max_length=max_length,
    )


@dataclass
class _ValidatorConfig:
    fields: Tuple[str, ...]
    func: Callable[..., Any]
    pre: bool
    each_item: bool


@dataclass
class _ModelValidatorConfig:
    func: Callable[..., Any]
    mode: str


def validator(*fields: str, pre: bool = False, each_item: bool = False) -> Callable[[Callable[..., Any]], Callable[..., Any]]:
    if not fields:
        raise ValueError("validator requires at least one field name")

    def decorator(func: Callable[..., Any]) -> Callable[..., Any]:
        setattr(func, "__pydantic_validator__", _ValidatorConfig(fields, func, pre, each_item))
        return func

    return decorator


def model_validator(*, mode: str = "after") -> Callable[[Callable[..., Any]], Callable[..., Any]]:
    def decorator(func: Callable[..., Any]) -> Callable[..., Any]:
        setattr(func, "__pydantic_model_validator__", _ModelValidatorConfig(func, mode))
        return func

    return decorator


class ModelMeta(type):
    def __new__(mcls, name: str, bases: Tuple[type, ...], namespace: Dict[str, Any]):
        annotations = namespace.get("__annotations__", {})
        field_definitions: Dict[str, FieldInfo] = {}
        validators: List[_ValidatorConfig] = []
        model_validators: List[_ModelValidatorConfig] = []

        for base in reversed(bases):
            if hasattr(base, "__fields__"):
                field_definitions.update(getattr(base, "__fields__"))
            if hasattr(base, "__validators__"):
                validators.extend(getattr(base, "__validators__"))
            if hasattr(base, "__model_validators__"):
                model_validators.extend(getattr(base, "__model_validators__"))

        for attr, value in list(namespace.items()):
            if hasattr(value, "__pydantic_validator__"):
                validators.append(getattr(value, "__pydantic_validator__"))
            if hasattr(value, "__pydantic_model_validator__"):
                model_validators.append(getattr(value, "__pydantic_model_validator__"))

        for field_name, annotation in annotations.items():
            field_value = namespace.get(field_name, _MISSING)
            if isinstance(field_value, FieldInfo):
                field_definitions[field_name] = field_value
                namespace.pop(field_name, None)
            elif field_value is not _MISSING:
                field_definitions[field_name] = FieldInfo(default=field_value)
            elif field_name not in field_definitions:
                field_definitions[field_name] = FieldInfo()

        cls = super().__new__(mcls, name, bases, namespace)
        cls.__fields__ = field_definitions
        cls.__validators__ = validators
        cls.__model_validators__ = model_validators
        cls.__annotations__ = annotations
        return cls


class BaseModel(metaclass=ModelMeta):
    __fields__: Dict[str, FieldInfo]
    __validators__: List[_ValidatorConfig]
    __model_validators__: List[_ModelValidatorConfig]
    __annotations__: Dict[str, Any]

    def __init__(self, **data: Any) -> None:
        for key, value in data.items():
            setattr(self, key, value)

    def model_dump(self) -> Dict[str, Any]:
        return {key: _serialize(getattr(self, key)) for key in self.__annotations__ if hasattr(self, key)}

    @classmethod
    def model_validate(cls: Type[_T], data: Mapping[str, Any]) -> _T:
        if not isinstance(data, Mapping):
            raise ValidationError(["Input must be a mapping"], cls)
        errors: List[str] = []
        values: Dict[str, Any] = {}
        for field_name, annotation in cls.__annotations__.items():
            field_info = cls.__fields__.get(field_name, FieldInfo())
            raw_value = data.get(field_name, _MISSING)
            if raw_value is _MISSING:
                if field_info.default_factory is not None:
                    raw_value = field_info.default_factory()
                elif field_info.default is not _MISSING:
                    raw_value = field_info.default
                elif _is_optional(annotation):
                    raw_value = None
                else:
                    errors.append(f"Missing field '{field_name}'")
                    continue

            try:
                raw_value = cls._apply_validators(field_name, raw_value, pre=True)
                parsed_value = _convert_value(annotation, raw_value, field_name)
                parsed_value = cls._apply_validators(field_name, parsed_value, pre=False)
                _check_constraints(field_name, parsed_value, field_info)
            except ValidationError as exc:
                errors.extend(exc.errors)
                continue
            except Exception as exc:
                errors.append(f"Field '{field_name}': {exc}")
                continue
            values[field_name] = parsed_value

        if errors:
            raise ValidationError(errors, cls)

        instance = cls(**values)
        for config in cls.__model_validators__:
            if config.mode == "after":
                result = config.func(instance)
                if result is not None:
                    instance = result
        return instance

    @classmethod
    def _apply_validators(cls, field: str, value: Any, pre: bool) -> Any:
        for validator_cfg in cls.__validators__:
            if validator_cfg.pre != pre:
                continue
            if field not in validator_cfg.fields:
                continue
            func = validator_cfg.func
            if validator_cfg.each_item and isinstance(value, Sequence) and not isinstance(value, (str, bytes, bytearray)):
                value = [func(cls, item) for item in value]
            else:
                value = func(cls, value)
        return value

    @classmethod
    def model_json_schema(cls) -> Dict[str, Any]:
        properties: Dict[str, Any] = {}
        required: List[str] = []
        for field_name, annotation in cls.__annotations__.items():
            field_info = cls.__fields__.get(field_name, FieldInfo())
            schema = _schema_for_annotation(annotation, field_info)
            properties[field_name] = schema
            if field_info.required and not _is_optional(annotation):
                required.append(field_name)
        schema: Dict[str, Any] = {"title": cls.__name__, "type": "object", "properties": properties}
        if required:
            schema["required"] = required
        return schema


def _serialize(value: Any) -> Any:
    if isinstance(value, BaseModel):
        return value.model_dump()
    if isinstance(value, (list, tuple)):
        return [_serialize(item) for item in value]
    if isinstance(value, (datetime, date)):
        return value.isoformat()
    return value


def _check_constraints(field_name: str, value: Any, info: FieldInfo) -> None:
    if value is None:
        return
    if info.ge is not None:
        if not isinstance(value, (int, float)) or value < info.ge:
            raise ValueError(f"Field '{field_name}' must be >= {info.ge}")
    if info.le is not None:
        if not isinstance(value, (int, float)) or value > info.le:
            raise ValueError(f"Field '{field_name}' must be <= {info.le}")
    if info.min_length is not None and hasattr(value, "__len__"):
        if len(value) < info.min_length:
            raise ValueError(f"Field '{field_name}' length must be >= {info.min_length}")
    if info.max_length is not None and hasattr(value, "__len__"):
        if len(value) > info.max_length:
            raise ValueError(f"Field '{field_name}' length must be <= {info.max_length}")


def _is_optional(annotation: Any) -> bool:
    origin = get_origin(annotation)
    if origin is Union:
        return type(None) in get_args(annotation)
    return False


def _convert_value(annotation: Any, value: Any, field_name: str) -> Any:
    origin = get_origin(annotation)
    if origin is Union:
        for arg in get_args(annotation):
            if arg is type(None):
                if value is None:
                    return None
                continue
            try:
                return _convert_value(arg, value, field_name)
            except Exception:
                continue
        raise ValidationError([f"Field '{field_name}' does not match any allowed type"], BaseModel)
    if origin in (list, List, Sequence, tuple):
        if value is None:
            return [] if origin is not tuple else ()
        if not isinstance(value, (list, tuple)):
            raise TypeError(f"Field '{field_name}' must be a sequence")
        item_type = get_args(annotation)[0] if get_args(annotation) else Any
        return [_convert_value(item_type, item, field_name) for item in value]
    if origin in (dict, Dict):
        if not isinstance(value, Mapping):
            raise TypeError(f"Field '{field_name}' must be a mapping")
        key_type, val_type = get_args(annotation) if get_args(annotation) else (Any, Any)
        return {
            _convert_value(key_type, key, field_name): _convert_value(val_type, val, field_name)
            for key, val in value.items()
        }
    if origin is Literal:
        allowed = get_args(annotation)
        if value not in allowed:
            raise ValueError(f"Field '{field_name}' must be one of {allowed}")
        return value
    if isinstance(annotation, type):
        if issubclass(annotation, BaseModel):
            return annotation.model_validate(value)
        if annotation is str:
            return str(value)
        if annotation is int:
            return int(value)
        if annotation is float:
            return float(value)
        if annotation is bool:
            if isinstance(value, bool):
                return value
            if isinstance(value, str):
                lowered = value.lower()
                if lowered in {"true", "1", "yes"}:
                    return True
                if lowered in {"false", "0", "no"}:
                    return False
            return bool(value)
        if annotation is datetime:
            if isinstance(value, datetime):
                return value
            if isinstance(value, str):
                value = value.replace("Z", "+00:00")
                return datetime.fromisoformat(value)
            raise TypeError(f"Field '{field_name}' must be a datetime")
        if annotation is date:
            if isinstance(value, date):
                return value
            if isinstance(value, str):
                return date.fromisoformat(value)
            raise TypeError(f"Field '{field_name}' must be a date")
    return value


def _schema_for_annotation(annotation: Any, info: FieldInfo) -> Dict[str, Any]:
    origin = get_origin(annotation)
    if origin in (list, List, Sequence, tuple):
        item_type = get_args(annotation)[0] if get_args(annotation) else Any
        schema = {
            "type": "array",
            "items": _schema_for_annotation(item_type, FieldInfo()),
        }
    elif origin is Union:
        args = [arg for arg in get_args(annotation) if arg is not type(None)]
        if len(args) == 1:
            schema = _schema_for_annotation(args[0], info)
            schema["nullable"] = True
        else:
            schema = {"anyOf": [_schema_for_annotation(arg, info) for arg in args]}
    elif origin is Literal:
        schema = {"enum": list(get_args(annotation))}
    elif isinstance(annotation, type):
        if issubclass(annotation, BaseModel):
            schema = {"$ref": annotation.__name__}
        elif annotation is str:
            schema = {"type": "string"}
        elif annotation is int:
            schema = {"type": "integer"}
        elif annotation is float:
            schema = {"type": "number"}
        elif annotation is bool:
            schema = {"type": "boolean"}
        elif annotation is datetime:
            schema = {"type": "string", "format": "date-time"}
        elif annotation is date:
            schema = {"type": "string", "format": "date"}
        else:
            schema = {"type": "string"}
    else:
        schema = {"type": "string"}
    if info.description:
        schema["description"] = info.description
    if info.ge is not None:
        schema["minimum"] = info.ge
    if info.le is not None:
        schema["maximum"] = info.le
    if info.min_length is not None:
        schema["minLength"] = info.min_length
    if info.max_length is not None:
        schema["maxLength"] = info.max_length
    if info.default is not _MISSING:
        schema["default"] = _serialize(info.default)
    return schema
