from django.contrib.auth.tokens import PasswordResetTokenGenerator
from django.utils.encoding import force_str
from six import text_type
class TokenGenerator(PasswordResetTokenGenerator):
    def _make_hash_value(self, user, timestamp):
        return (
            force_str(user.pk) + str(timestamp)
        )

generate_token = TokenGenerator()

