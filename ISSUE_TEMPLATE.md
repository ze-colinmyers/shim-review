Confirm the following are included in your repo, checking each box:

 - [✓] completed README.md file with the necessary information
 - [✓] shim.efi to be signed
 - [✓] public portion of your certificate(s) embedded in shim (the file passed to VENDOR_CERT_FILE)
 - [✓] binaries, for which hashes are added to vendor_db ( if you use vendor_db and have hashes allow-listed )
 - [✓] any extra patches to shim via your own git tree or as files
 - [✓] any extra patches to grub via your own git tree or as files
 - [✓] build logs
 - [✓] a Dockerfile to reproduce the build of the provided shim EFI binaries

*******************************************************************************
### What is the link to your tag in a repo cloned from rhboot/shim-review?
*******************************************************************************
`https://github.com/user/shim-review/tree/myorg-shim-arch-YYYYMMDD`

*******************************************************************************
### What is the SHA256 hash of your final SHIM binary?
*******************************************************************************

```plain
09b087cd41b73858c3710c19d39cdfc6b9e5fa910147c9eb24e7b5775b00434f  shimia32.efi
3b81fd7b864be4bd44a7d6130cfb469413477ae5b7376531cbe535a97b696478  shimx64.efi
```

*******************************************************************************
### What is the link to your previous shim review request (if any, otherwise N/A)?
*******************************************************************************
N/A

*******************************************************************************
### If no security contacts have changed since verification, what is the link to your request, where they've been verified (if any, otherwise N/A)?
*******************************************************************************
N/A
