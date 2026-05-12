# Security — Verifying a Tsunami Unleashed Build

Every deployed build of `tsunamiunleashed.com` ships a `MANIFEST.json` at
the site root, listing every file and its SHA-256. That manifest is signed
with minisign. You can verify any deploy (or any mirror) matches an
authentic ministry release by checking the signature against our
public key.

## Public key

```
RWScAEpW8ABYmI3cEspjBGoG2+yVovri0yV81FP3H5oigcBDLaaM8Iqd
```

- **Key ID (fingerprint):** `985800F0564A009C`
- **File:** [static/.well-known/minisign.pub](static/.well-known/minisign.pub)
- **DNS TXT publication:** deferred — will be added as
  `tsunami-pubkey=<key>` on `tsunamiunleashed.com` before the
  `v2026.05.0` release tag.

If a downloaded copy of the public key does not match both the base64
line above and the key ID `985800F0564A009C`, stop and do not trust the
build.

## Verify

```bash
# From a local checkout (requires minisign installed)
bash scripts/verify.sh

# Or manually against a deployed build
curl -O https://tsunamiunleashed.com/MANIFEST.json
curl -O https://tsunamiunleashed.com/MANIFEST.json.minisig
curl -O https://tsunamiunleashed.com/.well-known/minisign.pub
minisign -Vm MANIFEST.json -P "$(cat minisign.pub)"
```

A `Signature and comment signature verified` result means the files you
received are byte-for-byte identical to what was built and signed at the
canonical source. If verification fails, **do not trust the build** —
the site has been tampered with, mirrored incorrectly, or the signature
has rotated.

## Reporting a security issue

This is a static, public-domain resource site. There is no login, no
database, no user data to compromise, and no donation/payment flow to
abuse. If you find an actual vulnerability (e.g. signature bypass, build
pipeline compromise, malicious mirror impersonating the canonical site),
open an issue at
<https://github.com/TsunamiUnleashed/tsunamiunleashed.com/issues> or
reach Edward directly.
