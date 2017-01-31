#!/usr/bin/env python
# -*- coding: utf-8 -*-
# Name:
# Date:

from models import Comments
from rest_framework import serializers

class CommentsSerializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = Comments
        fields = ('url', 'id', 'name', 'email', 'comment', 'publish_date', 'agent')