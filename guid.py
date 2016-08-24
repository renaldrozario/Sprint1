#This Python file uses the following encoding: utf-8
#!/usr/local/bin/python
# coding: latin-1
from __future__ import print_function
import SoftLayer
import json
import sys
imagename = sys.argv[1]
from SoftLayer.managers.vs import VSManager
client = SoftLayer.create_client_from_env()
img = SoftLayer.ImageManager(client)
for ysi1 in img.list_private_images(name=imagename):
	print(ysi1['globalIdentifier'])
