
# IBAN.cr

Verifies the validity of [IBAN](https://en.wikipedia.org/wiki/International_Bank_Account_Number) International Bank Account Numbers. Verification of national check digits is not implemented.

### Using this shard
 
Add to your shard.yml

```
dependencies:
  iban:
    github: sikoba/iban.cr
```

Then add at the beginning of your .cr

```
require "iban"
```


### Check IBAN format (true/false)

Correct IBAN:
```
iban = "BE71 0961 2345 6769"
res = Iban.validate(iban) #=> true
```
 Incorrect IBAN:
```
iban = "BE17 0961 2345 6769"
res = Iban.validate(iban) #=> false
```

### Check IBAN format (with explicit messages)

Correct IBAN:
```
iban = "BE71 0961 2345 6769"
res = Iban.validate_with_feedback(iban) #=> "OK"
```
 Incorrect IBAN:
```
iban = "BE17 0961 2345 6769"
res = Iban.validate_with_feedback(iban) #=> "IBAN checksum incorrect"
```

### Format IBAN in the standard way

```
iban = "  Br150  0000000000  01093 2840814p2   "
res = Iban.display(iban) #=> "BR15 0000 0000 0000 1093 2840 814P 2"
```
Note that this function does not check if the IBAN format is correct!
