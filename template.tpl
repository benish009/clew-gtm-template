___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "TAG",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Clew",
  "description": "Loads the Clew widget so product tours, tooltips, modals and onboarding checklists built in Clew run on this site.",
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "siteKey",
    "displayName": "Site key",
    "simpleValueType": true,
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ],
    "help": "The key of the site in Clew: dashboard, the site, Install. It looks like pk_ followed by letters and digits. It is a public key, safe to ship to the browser."
  },
  {
    "type": "SELECT",
    "name": "host",
    "displayName": "Clew instance",
    "selectItems": [
      {
        "value": "https://tryclew.io",
        "displayValue": "tryclew.io - EU cloud (Amsterdam)"
      },
      {
        "value": "https://tryclew.ru",
        "displayValue": "tryclew.ru - RU cloud (Moscow)"
      }
    ],
    "simpleValueType": true,
    "defaultValue": "https://tryclew.io",
    "help": "Which Clew instance the account lives on. A self-hosted Clew is not loaded by this template: use a Custom HTML tag with your own host instead."
  },
  {
    "type": "TEXT",
    "name": "pinnedVersion",
    "displayName": "Pinned widget version (optional)",
    "simpleValueType": true,
    "help": "Leave empty to always load the current widget. Set it to a version from the Install screen to freeze the widget at that build."
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

const injectScript = require('injectScript');
const log = require('logToConsole');

const host = data.host || 'https://tryclew.io';
const key = data.siteKey;
const version = data.pinnedVersion;

// rolling by default; a pinned version uses the immutable, year-cached URL
let url = host + '/widget/' + key + '.js';
if (version && version.length > 0) {
  url = host + '/widget/v/' + version + '/' + key + '.js';
}

const cacheToken = 'clew_' + key + (version || '');

injectScript(url, data.gtmOnSuccess, function () {
  log('Clew: could not load ' + url);
  data.gtmOnFailure();
}, cacheToken);


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "inject_script",
        "versionId": "1"
      },
      "param": [
        {
          "key": "urls",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "https://tryclew.io/*"
              },
              {
                "type": 1,
                "string": "https://tryclew.ru/*"
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "versionId": "1"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "debug"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___NOTES___

Created on 2026-10-04

Loads the Clew widget for one site. Which tour runs, on which page and for which visitor is decided
inside Clew, so this tag normally fires once on All Pages. It sends nothing to Clew by itself and
reads nothing from the page.

Self-hosted Clew is not loadable here: a template may only fetch scripts from hosts declared inside
it. Use a Custom HTML tag for that.
