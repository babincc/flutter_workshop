## 2.0.0-beta.15 - January 27, 2025

- Breaking change: Removed the hashers and equality checkers from Misc Tools
- Updated the way resources are fetched and PUT to make the actions more efficient, and to more properly handle errors

## 2.0.0-beta.14 - January 24, 2025

- Added `failedFetches` and related methods to `HueNetwork`. This addresses [issue #25](https://github.com/babincc/flutter_workshop/issues/25) and gives devs a way to retry failed fetches

## 2.0.0-beta.13 - January 23, 2025

- Fixed UI bug with example

## 2.0.0-beta.12 - January 22, 2025

- Downgraded color converter to work with older versions of Flutter
- Downgraded some dependencies to work with older versions of Flutter

## 2.0.0-beta.11 - January 17, 2025

- Updated example to allow easier testing by giving devs access to previously connected bridges

## 2.0.0-beta.10 - January 16, 2025

- Downgraded `path_provider` for dependency conflicts

## 2.0.0-beta.9 - January 16, 2025

- Downgraded `url_launcher` for dependency conflicts

## 2.0.0-beta.8 - January 16, 2025

- Removed data check for light gradient points

## 2.0.0-beta.7 - January 15, 2025

- Breaking change: Color calculators now treat RGB values are doubles instead of integers
- Updated dependencies
- Fixed linting issues

## 2.0.0-beta.6 - January 15, 2025

- Updated example

## 2.0.0-beta.5 - August 6, 2024

- Documentation updates

## 2.0.0-beta.4 - July 17, 2024

- Breaking change: Gave access to bridge IDs when `BridgeDiscoveryRepo.discoverBridges()` is called [issue #20](https://github.com/babincc/flutter_workshop/issues/20)

## 2.0.0-beta.3 - June 12, 2024

- Added platforms that were accidentally dropped

## 2.0.0-beta.2 - June 12, 2024

- Attempted environment fix to add platforms that were accidentally dropped

## 2.0.0-beta.1 - June 11, 2024

- Added Entertainment Streaming
- Breaking changes in places such as `put` and `post` commands

## 1.2.5 - March 18, 2024

- Removed some assertions to allow to third party products that don't follow the same rules as official Philips Hue products [issue #16](https://github.com/babincc/flutter_workshop/issues/16)

## 1.2.4 - February 15, 2024

- Small documentation fix

## 1.2.3 - February 9, 2024

- Fixed issue tracker link

## 1.2.2 - September 27, 2023

- Documentation updates

## 1.2.1 - June 12, 2023

- Fixed type cast bug [issue #9](https://github.com/babincc/flutter_workshop/issues/9)

## 1.2.0 - April 19, 2023

- Linked objects that are all in the same Hue Network [issue #6](https://github.com/babincc/flutter_workshop/issues/6)
- Added general PUT command to Hue Network

## 1.1.0 - April 17, 2023

- Added maintenance repo to keep local storage up to date
- Added color converters [issue #2](https://github.com/babincc/flutter_workshop/issues/2)
- Added Philips Hue icons [issue #3](https://github.com/babincc/flutter_workshop/issues/3)

## 1.0.0 - April 14, 2023

- Added the ability to make remote connection to the user's Philips Hue devices [issue #1](https://github.com/babincc/flutter_workshop/issues/1)
- Breaking change: Locally stored info is now encrypted
- Fixed bugs when doubles were pulled from JSON objects as integers

## 0.1.1 - April 7, 2023

- Documentation updates

## 0.1.0 - March 11, 2023

- Initial release
