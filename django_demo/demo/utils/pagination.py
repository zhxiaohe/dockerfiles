#!/usr/bin/env python
# -*- coding: utf-8 -*-
# Name:
# Date:

from collections import OrderedDict
from rest_framework.pagination import PageNumberPagination
from rest_framework.response import Response

class StandardResultsSetPagination(PageNumberPagination):
    page_size_query_param = 'page_size'
    max_page_size = 500
    def get_paginated_response(self, data):
        page_size = self.request.query_params.get('page_size') if self.request.query_params.get('page_size') else self.page_size
        return Response(OrderedDict([
            ('total_count', self.page.paginator.count),
            ('page_count', self.page.paginator.num_pages),
            ('current_page', self.page.number),
            ('page_size', page_size),
            ('next', self.get_next_link()),
            ('previous', self.get_previous_link()),
            ('results', data)
        ]))