import { AsyncValidator, AbstractControl, ValidationErrors } from "@angular/forms";
import { Observable, of } from "rxjs";
import { UsersService } from "../openapi/lingua-poly";
import { map, catchError, tap, switchMap } from "rxjs/operators";
import { Injectable } from "@angular/core";

@Injectable({ providedIn: 'root' })
export class UsernameAvailableValidator implements AsyncValidator {
	constructor(
		private usersService: UsersService
	) {}

	validate(
		control: AbstractControl
	): Promise<ValidationErrors | null> | Observable<ValidationErrors | null> {
		if (!control.value.length) {
			console.log('no value yet');
			return of(null);
		}


		console.log('control.value:', control.value);

		return this.usersService.getUserByName(control.value).pipe(
			map(() => { return { unavailable: true }}),
			catchError(() => null)
		);
	}
}
