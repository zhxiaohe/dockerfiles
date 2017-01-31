#!/usr/bin/env python
# -*- coding: utf-8 -*-
# Name:
# Date:

from django.conf.urls import url
from django.conf.urls import include
from rest_framework import routers
from comments import views

router = routers.DefaultRouter()
router.register(r'comments', views.CommentsViewSet)

urlpatterns = [
    url(r'^api/', include(router.urls)),
]
