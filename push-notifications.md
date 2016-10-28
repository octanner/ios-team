# Let's make a new Push Certificate

There are lots of steps, but they're all easy.

1. Make a password that's decent
  ```
  $ head /dev/urandom | shasum -a 256
  1733e7c3f7d29f671b48818081f9fb95c2ff0dac9ea67870e74430f193b4caf3  -
  ```

2. Place the password into a file, `.env` like this
  ```
  pass=1733e7c3f7d29f671b48818081f9fb95c2ff0dac9ea67870e74430f193b4caf3
  ```

3. Pull the password into the shell environment, without typing it.
  ```
  $ source .env
  ```

4. Generate an RSA key encrypted with the password.
  ```
  $ openssl genrsa -aes256 -passout pass:$pass -out prod-2016.key 2048
  ```

5. Generate a CSR file to upload to Apple. Don't answer any of the questions; they don't matter.
  ```
  $ openssl req -new -key prod-2016.key -out prod-2016.csr -passin pass:$pass
  ```

6. Upload the CSR to Apple, and download the certificate file.
  > This gives you a `aps.cer` file in your Downloads directory.

7. Convert the certificate file to PEM format.
  ```
  $ openssl x509 -in ~/Downloads/aps.cer -inform DER -outform PEM -out prod-2016.crt
  ```

8a. *RUBY:* Put the key and cert into a single PEM file for Houston
  ```
  cat prod-2016.key prod-2016.crt > prod-2016.pem
  ```

8b. *JAVA:* Put the key and cert into a single p12 file
  ```
  openssl pkcs12 -export -inkey prod-2016.key -in prod-2016.crt -passin pass:$pass -out prod-2016.p12 -passout pass:$pass
  ```

*DONE!*
