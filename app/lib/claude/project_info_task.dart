// What a project info run does: read the project folder once, when the
// project is added, and save what Deck shows it with and matches messages to.
import '../core/platforms.dart';

/// [board] is set when Deck already found it on the forge.
String projectInfoPrompt(String folderName, {String? board}) =>
    '''
You are reading the project in the current folder for Deck, a work board.
Work alone: nobody answers questions in this session. Read with Read, Grep,
Glob and read only git commands. Never edit a file. Be quick: this is a
survey, not a review. Read manifests, not source code.

Save time with helpers: start three Agent helpers in one message, so they
run at the same time, each told to read only and report in a few lines:
- **app**: items 1 to 6 below, the logo path checked with Read;
- **git**: ${board != null ? 'the ticket prefixes of item 3' : 'item 7 and the ticket prefixes of item 3'}, from
  `git log -300 --all --format=%s`;
- **slack**: item 8, given the folder name and the main app names. Tell it
  to first skim the README for the product's key terms (its parts,
  protocols, services). Skip this helper when no `slack_search_channels`
  tool is there.
Do item 9 yourself from what they report, then save.

Deck needs:

1. **name**: the product name people say in Slack and mail ("Acme VPN"),
   not the folder name ("$folderName"). When the folder holds several apps
   of one product (Android and iOS, app and backend), use the product name.
   Never put the platform in the name: platforms say it.
2. **description**: one sentence: what it is, which platforms or what it serves.
3. **aliases**: every other name a message may use for it. Look at:
   - app display names: `AndroidManifest.xml` `android:label` and
     `strings.xml` `app_name`, `Info.plist` `CFBundleDisplayName` and
     `CFBundleName`, `pubspec.yaml`, `package.json`, extension `manifest.json`,
     Windows `Runner.rc` `ProductName`, store listing files;
   - bundle and package ids: `applicationId`, `PRODUCT_BUNDLE_IDENTIFIER`,
     `package` in `pubspec.yaml` or `package.json`;
   - the repo name, from `.git/config`;
   - ticket prefixes in recent commit subjects
     (`git log -300 --all --format=%s`): "AVPN-123" gives "AVPN".
   Keep each alias short, drop duplicates and generic words ("app", "android").
4. **logo**: the app icon, a PNG, JPEG, WebP or SVG file in the folder. Prefer
   the biggest square one: an iOS or macOS `AppIcon.appiconset` 1024 or 512
   image, Android `mipmap-xxxhdpi/ic_launcher.png`, `web/icons/Icon-512.png`,
   an extension's 128 icon, a `logo.svg` or `logo.png` in the docs. Android
   vector drawables (XML) and ICO files do not work. Look at your pick with
   Read to check it is the product's icon, not a framework placeholder
   (the default Flutter or Android icon). Leave it out when there is none.
5. **platforms**: where it runs, from: ${platforms.keys.join(', ')}. "apple"
   covers iOS and macOS, "other" when nothing fits. Only platforms the folder really builds for: a
   Flutter app with only `android/` and `windows/` is android and windows.
6. **tech**: the main languages, frameworks and build tools, a few words.
7. **board**: ${board != null ? 'already set to "$board" by Deck: leave it out.' : '''"jira:KEY" only when this project's own tickets live in Jira:
   most commits use one ticket prefix that names this product or team
   ("AVPN-123" gives "jira:AVPN"). Leave it out when the prefix looks like
   a company wide board (operations, maintenance, IT, support) or you are
   unsure.'''}
8. **channels**: the Slack channels about this project. Channel names often
   do not hold the product name: "#project-ohttp-proxy" and
   "#crumbs-proxy-work" can both be about one product. So find them two ways:
   - by name and topic: `slack_search_channels` for the name, the main
     aliases and the key terms;
   - by content: if `slack_search_public_and_private` is there, search
     messages of the last six months for the name and the main aliases,
     and note the channels they come up in again and again.
   Keep only channels whose name, topic or messages are clearly about this
   product (its team, its parts, its releases, its alerts), not company wide
   or general channels where it comes up once. Leave it out when unsure.
9. **ide**: the command that opens the folder in the IDE that fits:
   `xed` for an Xcode project, `studio` for an Android only project, `idea`
   for Flutter, Kotlin or Java, `code` for web, TypeScript, Python or Go.

Then call `set_project_info` once with what you found. If it refuses the
logo, pick another file or leave the logo out.
''';
