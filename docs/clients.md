# Supported WoW client

**Expansion:** Battle for Azeroth (BfA)  
**Patch target:** 8.3.7  
**Common build IDs:** 35662 (and nearby maintenance builds).

## Detect client build locally
On a machine with the retail client installed, read `Data/build.info`.

- Windows: `World of Warcraft\\_retail_\\Data\\build.info`
- macOS: `/Applications/World of Warcraft/_retail_/Data/build.info`
- Linux/Wine: `<WoW>/_retail_/Data/build.info`

Or run:
```bash
python3 tools/detect_client.py /path/to/_retail_/Data/build.info
```
The core should be compatible with the printed build ID when it matches the supported list above. If not, please open an issue with your build ID.
