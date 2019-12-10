import { FormGroup, AbstractControl, ValidationErrors } from '@angular/forms';

export class UsernameValidator {
	static username(control: AbstractControl): ValidationErrors | null {
		if (!control) return null;

		const username = control.value;

		if (username.includes('/')) return { slash: true };
		if (username.includes('@')) return { atSign: true };

		return null;
	}
}
