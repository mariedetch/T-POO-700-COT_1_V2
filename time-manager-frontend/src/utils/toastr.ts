import {useToast} from 'vue-toast-notification';
import 'vue-toast-notification/dist/theme-sugar.css';

export class ToastrService {
  static success(message: string) {
    const $toast = useToast();
    $toast.open({
      message: message,
      position: 'top-right',
      duration: 10000
    });
  }

  static error(message: string) {
    const $toast = useToast();
    $toast.open({
      message: message,
      position: 'top-right',
      type: 'error',
      duration: 10000
    });
  }
}

