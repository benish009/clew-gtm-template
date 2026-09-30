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
  "categories": ["PERSONALIZATION", "UTILITY"],
  "brand": {
    "id": "brand_dummy",
    "displayName": "Clew"
  },
  "description": "Loads the Clew widget so product tours, tooltips, modals and onboarding checklists built in Clew run on this site. Needs the site key from the Clew dashboard.",
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
    "help": "The key of the site in Clew: dashboard → the site → Install. It looks like pk_ followed by letters and digits. It is a public key, safe to ship to the browser.",
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      },
      {
        "type": "REGEX",
        "args": [
          "^[A-Za-z0-9_-]{8,64}$"
        ],
        "errorMessage": "A site key is 8 to 64 characters: letters, digits, underscore and hyphen. Copy it from the Install screen without the surrounding script tag."
      }
    ]
  },
  {
    "type": "SELECT",
    "name": "host",
    "displayName": "Clew instance",
    "macrosInSelect": false,
    "selectItems": [
      {
        "value": "https://tryclew.io",
        "displayValue": "tryclew.io — EU cloud (Amsterdam)"
      },
      {
        "value": "https://tryclew.ru",
        "displayValue": "tryclew.ru — RU cloud (Moscow)"
      }
    ],
    "simpleValueType": true,
    "defaultValue": "https://tryclew.io",
    "help": "Which Clew instance the account lives on. A self-hosted Clew is not loaded by this template — use a Custom HTML tag with your own host instead, because a Tag Manager template may only fetch scripts from hosts declared in it."
  },
  {
    "type": "TEXT",
    "name": "pinnedVersion",
    "displayName": "Pinned widget version (optional)",
    "simpleValueType": true,
    "help": "Leave empty to always load the current widget. Set it to a version reported on the Install screen to freeze the widget at that build: the URL becomes immutable and is cached for a year. Pinning means fixes stop arriving until you change it.",
    "valueValidators": [
      {
        "type": "REGEX",
        "args": [
          "^[A-Za-z0-9._-]{0,32}$"
        ],
        "errorMessage": "A version is up to 32 characters: letters, digits, dot, underscore and hyphen."
      }
    ]
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

// Clew loads one script. Everything else — which tour runs, on which page, for whom — is decided
// in Clew itself, so this template has exactly one job: build the right URL and inject it.
const injectScript = require('injectScript');
const log = require('logToConsole');

const host = data.host || 'https://tryclew.io';
const key = data.siteKey;
const version = data.pinnedVersion;

// Two shapes, both served by Clew:
//   rolling  <host>/widget/<key>.js            revalidated, always the current build
//   pinned   <host>/widget/v/<version>/<key>.js  immutable, cached for a year
const url = version && version.length > 0
  ? host + '/widget/v/' + version + '/' + key + '.js'
  : host + '/widget/' + key + '.js';

// The cache token keeps Tag Manager from injecting the same widget twice when the tag fires on
// more than one trigger; the widget itself is also idempotent, but this saves the request.
const cacheToken = 'clew_' + key + (version || '');

injectScript(url, data.gtmOnSuccess, function () {
  log('Clew: could not load ' + url + '. Check the site key and that the domain is allowed in Clew.');
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


___TESTS___

scenarios:
- name: the rolling URL is used when no version is pinned
  code: |-
    const mockData = { siteKey: 'pk_abc123def456', host: 'https://tryclew.io', pinnedVersion: '' };
    let injected = '';
    mock('injectScript', (url, onSuccess) => { injected = url; onSuccess(); });

    runCode(mockData);

    assertThat(injected).isEqualTo('https://tryclew.io/widget/pk_abc123def456.js');
    assertApi('gtmOnSuccess').wasCalled();
- name: a pinned version uses the immutable URL
  code: |-
    const mockData = { siteKey: 'pk_abc123def456', host: 'https://tryclew.io', pinnedVersion: '12' };
    let injected = '';
    mock('injectScript', (url, onSuccess) => { injected = url; onSuccess(); });

    runCode(mockData);

    assertThat(injected).isEqualTo('https://tryclew.io/widget/v/12/pk_abc123def456.js');
- name: the Russian instance is loaded from its own host
  code: |-
    const mockData = { siteKey: 'pk_abc123def456', host: 'https://tryclew.ru', pinnedVersion: '' };
    let injected = '';
    mock('injectScript', (url, onSuccess) => { injected = url; onSuccess(); });

    runCode(mockData);

    assertThat(injected).isEqualTo('https://tryclew.ru/widget/pk_abc123def456.js');
- name: a failed load reports failure rather than silently succeeding
  code: |-
    const mockData = { siteKey: 'pk_abc123def456', host: 'https://tryclew.io', pinnedVersion: '' };
    mock('injectScript', (url, onSuccess, onFailure) => { onFailure(); });

    runCode(mockData);

    assertApi('gtmOnFailure').wasCalled();
    assertApi('gtmOnSuccess').wasNotCalled();


___NOTES___

Created on 2026-09-30

What this tag does: it loads the Clew widget for one site. Clew is in-app guidance for web
products — anchored tooltip tours, modals, onboarding checklists and a two-step rating popup,
built in a visual editor on your own live site.

What it does not do: it sends nothing to Clew by itself and reads nothing from the page. Which
tour runs, on which page and for which visitor is decided inside Clew, not in Tag Manager, so
this tag normally fires once on All Pages.

Data: the widget reports tour views, completions and per-step drop-off against a random visitor
id generated in the browser. No IP address is stored. https://tryclew.io/legal/privacy

Self-hosted Clew: not loadable through this template. A Tag Manager template may only fetch
scripts from hosts declared inside it, and a self-hosted instance runs on your own domain. Use a
Custom HTML tag there.
