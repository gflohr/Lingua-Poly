import { AbstractControl, ValidationErrors } from '@angular/forms';

export class UrlValidator {
	static homepage(control: AbstractControl): ValidationErrors | null {
		if (!control.value.length) return null;

		// Taken from https://stackoverflow.com/a/5717133 and terribly
		// broken.
		var pattern = new RegExp('^(https?:\\/\\/)'+ // protocol
			'((([a-z\\d]([a-z\\d-]*[a-z\\d])*)\\.)+[a-z]{2,}|'+ // domain name
			'((\\d{1,3}\\.){3}\\d{1,3}))'+ // OR ip (v4) address
			'(\\:\\d+)?(\\/[-a-z\\d%_.~+]*)*'+ // port and path
			'(\\?[;&a-z\\d%_.~+=-]*)?'+ // query string
			'(\\#[-a-z\\d_]*)?$','i'); // fragment locator
		return !pattern.test(control.value) ? { homepage: true } : null;
	}

	// This is redundant with respect to homepage() but it catches the most
	// likely error early.
	static schema(control: AbstractControl): ValidationErrors | null {
		if (!control.value.length) return null;

		var pattern = new RegExp('^https?:\\/\\/');
		return !pattern.test(control.value) ? { schema: true } : null;
	}
}
