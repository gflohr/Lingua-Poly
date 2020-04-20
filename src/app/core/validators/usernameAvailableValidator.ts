import { AsyncValidator, AbstractControl, ValidationErrors } from '@angular/forms';
import { Observable, of } from 'rxjs';
import { UsersService } from '../openapi/lingua-poly';
import { map, catchError } from 'rxjs/operators';
import { Injectable } from '@angular/core';

@Injectable({ providedIn: 'root' })
export class UsernameAvailableValidator implements AsyncValidator {
	constructor(
		private usersService: UsersService
	) {}

	validate(
		control: AbstractControl
	): Promise<ValidationErrors | null> | Observable<ValidationErrors | null> {
		if (!control.value.length) {
			return of(null);
		}

		/* Check whether this was the originally chosen username.	This would
		 * cause a false positive.
		 */
		if (control.parent.getRawValue().originalUsername === control.value) {
			return of(null);
		}

		if (control.value.match(/^user-[0-9a-f]*$/i)) {
			return of({ reserved: true });
		}

		return this.usersService.getUserByName(control.value).pipe(
			map(() => ({ unavailable: true })),
			catchError(() => of(null)),
		);
	}
}
