import { defineRule, configure } from 'vee-validate';
import { required, email, min } from '@vee-validate/rules';
import { localize } from '@vee-validate/i18n';

defineRule('required', required);
defineRule('email', email);
defineRule('min', min);

configure({
  generateMessage: localize({
    en: {
      messages: {
        required: '{field} is required.',
        email: '{field} must be a valid email.',
        min: '{field} must have at least {length} characters.',
      },
      names: {
        email: 'Email',
        password: 'Password',
        username: 'Username',
      },
    },
  }),
  validateOnInput: true,
});
