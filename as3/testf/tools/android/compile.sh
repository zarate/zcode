#!/bin/bash
adt -package -target apk -storetype pkcs12 -keystore docs/cert/testfcert.pfx docs/testf.apk testf-descriptor.xml build/bin/testf.swf build/bin/tests.xml


#adt -installApp -platform android -platformsdk /home/zarate/software/sdk/android-sdk-linux_86 -package docs/testf.apk