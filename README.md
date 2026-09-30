# Clew — Google Tag Manager custom template

A Tag Manager tag that loads the [Clew](https://tryclew.io) widget on a site.

Clew is in-app guidance for web products: anchored tooltip tours, modals, onboarding checklists and
a two-step rating popup, built in a visual editor on your own live site.

## What the template does

It builds one URL and injects one script:

```
https://tryclew.io/widget/<site key>.js          # current build
https://tryclew.io/widget/v/<version>/<key>.js   # pinned build, immutable
```

That is the whole tag. Which tour runs, on which page and for which visitor is decided inside
Clew, so the tag normally fires once on **All Pages**.

## Fields

| Field | Required | Notes |
|---|---|---|
| **Site key** | yes | From the Clew dashboard → the site → Install. A public key; it is meant to be in your page source. |
| **Clew instance** | yes | `tryclew.io` (EU cloud, Amsterdam) or `tryclew.ru` (RU cloud, Moscow). |
| **Pinned widget version** | no | Empty means always the current widget. Setting it freezes the build — fixes stop arriving until you change it. |

## Self-hosted Clew

Not loadable through this template. A Tag Manager template may only fetch scripts from hosts
written into the template itself, and a self-hosted Clew runs on your own domain. Use a Custom
HTML tag there.

## Data

The widget reports tour views, completions and per-step drop-off against a random visitor id
generated in the browser. No IP address is stored.
[Privacy policy](https://tryclew.io/legal/privacy) · [Install guide](https://tryclew.io/install/google-tag-manager)

## Licence

This template is Apache-2.0 (see `LICENSE`), which is what the Community Template Gallery requires.
The licence covers the files in this repository — the template that loads Clew — and not the Clew
product itself.
