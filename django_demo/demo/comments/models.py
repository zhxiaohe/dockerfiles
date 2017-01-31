#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import unicode_literals

from django.db import models

class Comments(models.Model):
    name = models.CharField(u'用户昵称', max_length=64)
    email = models.EmailField(u'联系邮箱', max_length=255)
    comment = models.TextField(u'留言内容', max_length=2048)
    publish_date = models.DateTimeField(u'留言时间', auto_now_add=True)
    agent = models.CharField(u'浏览器类型', max_length=255)
    def __unicode__(self):
        return self.name
    class Meta:
        verbose_name = u'留言'
        verbose_name_plural = u'留言'
