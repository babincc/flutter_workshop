# Establishing Remote Connection

You can read Philips Hue's official documentation [here](https://developers.meethue.com/develop/hue-api/remote-authentication-oauth/).

This document explains how to establish a remote connection with devices connected to the user's Philips Hue account. This way, the user can interact with their bridge(s) even when their phone/computer is not on the same network.

## Set Up Your Hue Dev Account

The first thing you need to do is get some credentials through Philips Hue's website.

You will need to add an app-specific API ID [here](https://developers.meethue.com/my-apps/).

Note: You don't need to get this exactly right. `Callback URL`, `Display name`, and `Description` can be changed later.

`Callback URL` is formatted: `[scheme]://[domain]` - Example `flutterhue://auth`

## Authorization Request

Before the user can use your app to communicate remotely with their bridges, they need to log into their Philips Hue account and give your app permission to do so. To make this request, call:

```dart
BridgeDiscoveryRepo.remoteAuthRequest(
    clientId: "[clientId]",
    redirectUri: "flutterhue://auth", // "Callback URL" on Hue's site
);
```

Note: To get the values for the fields required in the above method, go to your remote hue API IDs [here](https://developers.meethue.com/my-apps/), and expand the one related to the app you are working on.

When this method is called, the user's browser will open up to Philips Hue's website. The user will log into their account and grant your app permission to talk to their devices. Once they do this, Philips Hue will redirect them back to your app. For this to work correctly, you will need to do a couple of things.

### iOS

`ios > Runner > Info.plist`

Add this and replace "flutterhue" with the _scheme_ part of your Callback URL that you set up in your Hue Dev account:

```
<key>LSApplicationQueriesSchemes</key>
<array>
    <string>https</string>
</array>
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>flutterhue</string>
        </array>
    </dict>
</array>
<key>FlutterDeepLinkingEnabled</key>
<true/>
```

### Android

`android > app > src > main > AndroidManifest.xml`

Add this inside of `manifest` before `application`:

```xml
<queries>
    <intent>
        <action android:name="android.intent.action.VIEW" />
        <data android:scheme="https" />
    </intent>
</queries>
```

Add this inside `activity` named ".MainActivity" and replace "flutterhue" with the _scheme_ part of your Callback URL that you set up in your Hue Dev account:

```xml
<meta-data
    android:name="flutter_deeplinking_enabled"
    android:value="true"
    />
<intent-filter>
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:scheme="flutterhue"/>
</intent-filter>
```

## Get Token

Once your app has permission to talk to the user's Philips Hue account, you will need to obtain a token. This is used so the user doesn't need to grant permission every time they want to send a command.

### Deep Linking

Once you have your iOS and Android configured, your app is ready to receive deep links. This means that Philips Hue's website will be able to open your app when the user is done there. This next step will show you how to handle the deep link.

Note: This is one of many ways to handle deep links. Feel free to use your favorite method.

#### Uni Links

First, you'll need to add [uni_links](https://pub.dev/packages/uni_links/install) to your project.

#### Deep Link Stream

At the root of your app, add a stream to listen for incoming deep links.

```dart
late final StreamSubscription deepLinkStream;

@override
void initState() {
    super.initState();

    deepLinkStream = uriLinkStream.listen(
        (Uri? uri) {
            if (uri == null) return;

            final int start = uri.toString().indexOf("?");
            String queryParams = uri.toString().substring(start);
            Uri truncatedUri = Uri.parse(queryParams);

            try {
                final String? pkce = truncatedUri.queryParameters[ApiFields.pkce];
                final String? code = truncatedUri.queryParameters[ApiFields.code];
                final String? resState =
                    truncatedUri.queryParameters[ApiFields.state];

                // Handle Flutter Hue deep link
                if (pkce != null && code != null && resState != null) {
                    // `clientID` and `clientSecret` are found in your Hue Dev
                    // account where you added your remote API ID.
                    TokenRepo.fetchRemoteToken(
                        clientId: "[clientId]",
                        clientSecret: "[clientSecret]",
                        pkce: pkce,
                        code: code,
                        stateSecret: resState,
                    );
                }
            } catch (_) {
                // Do nothing
            }
        },
    );
}

@override
void dispose() {
    // Don't forget to dispose the stream.
    deepLinkStream.cancel();

    super.dispose();
}
```

## Refresh Token

The access tokens expire. You will need to keep them up to date, or the user will need to grant the app permission again. To do this, call:

```dart
// `clientID` and `clientSecret` are found in your Hue Dev account where you
// added your remote API ID.
await TokenRepo.refreshRemoteToken(
    clientId: "[clientId]",
    clientSecret: "[clientSecret]",
);
```

It is possible for the refresh token to expire as well. If this is the case, you will need to get the user to grant permission again like they did in the Authorization Request section.

Note: Once a remote connection is established, there is no need to make special calls to handle remote vs local requests. Just follow the examples on the [Flutter Hue documentation](https://pub.dev/packages/flutter_hue), and it will be handled automatically.
