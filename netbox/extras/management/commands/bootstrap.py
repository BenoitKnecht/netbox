from django.core.management.base import BaseCommand
from django.contrib.auth.models import User
from users.models import Token

import os
import sys


class Command(BaseCommand):
    help = "Bootstrap NetBox deployment by setting up super user"

    def add_arguments(self, parser):
        parser.add_argument('name', help="Name of the super user")

    def handle(self, *args, **options):
        name = options['name']

        password = os.environ.get('SUPERUSER_PASSWORD')
        token = os.environ.get('SUPERUSER_API_TOKEN')

        users = User.objects.filter(username=name)
        if len(users) == 0 and password:
            print('Creating "{}" super user...'.format(name))
            user = User.objects.create_superuser(name, '', password)
        elif len(users) == 1:
            user = users[0]
        else:
            return

        if token:
            if not Token.objects.filter(user=user, key=token):
                print('Creating API token for "{}" super user...'.format(name))
                Token.objects.create(user=user, key=token)