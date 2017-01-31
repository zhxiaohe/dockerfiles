#!/usr/bin/env python
# -*- coding: utf-8 -*-
# Name:
# Date:

from models import Comments
from rest_framework import viewsets
from serializers import CommentsSerializer

class CommentsViewSet(viewsets.ModelViewSet):
    queryset = Comments.objects.all().order_by('-publish_date')
    serializer_class = CommentsSerializer