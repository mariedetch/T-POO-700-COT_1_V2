import { defineRule, configure } from 'vee-validate';
import { required, email, min, confirmed } from '@vee-validate/rules';
import { localize } from '@vee-validate/i18n';

defineRule('required', required);
defineRule('email', email);
defineRule('min', min);
defineRule('confirmed', confirmed);

configure({
  generateMessage: localize({
    en: {
      messages: {
        required: '{field} is required.',
        email: '{field} must be a valid email.',
        min: '{field} must have at least {length} characters.',
        confirmed: `{field} must match the password`
      },
      names: {
        email: 'Email',
        password: 'Password',
        password_confirm: 'Password Confirmation',
        username: 'Username',
      },
    },
  }),
  validateOnInput: true,
});
