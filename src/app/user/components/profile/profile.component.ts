import { Component } from '@angular/core';
import { FormBuilder } from '@angular/forms';
import { UsernameValidator } from 'src/app/core/validators/usernameValidator';
import { UrlValidator } from 'src/app/core/validators/urlValidator';
import { UsernameAvailableValidator } from 'src/app/core/validators/usernameAvailableValidator';

import * as fromAuth from '../../../auth/reducers';
import { Store, select } from '@ngrx/store';
import { Observable } from 'rxjs';
import { User } from 'src/app/core/openapi/lingua-poly';
import { tap } from 'rxjs/operators';
import { UserActions } from 'src/app/core/actions';

@Component({
	selector: 'app-profile',
	templateUrl: './profile.component.html',
	styleUrls: ['./profile.component.css']
})
export class ProfileComponent {
	user$: Observable<User>;

	constructor(
		private fb: FormBuilder,
		private usernameAvailableValidator: UsernameAvailableValidator,
		private authStore: Store<fromAuth.State>,
	) {
		this.user$ = this.authStore.pipe(
			select(fromAuth.selectUser),
			tap(user => {
				const username = user ? user.username : '';
				this.profileForm.patchValue({ originalUsername: username });
			})
		);
	}

	profileForm = this.fb.group({
		username: [
			'',
			UsernameValidator.username,
			this.usernameAvailableValidator.validate.bind(this.usernameAvailableValidator)
		],
		originalUsername: [''],
		homepage: ['', [UrlValidator.scheme, UrlValidator.hostname]],
		description: ['']
	}, {});

	onSubmit() {
		const profile = this.profileForm.getRawValue();
		delete profile.originalUsername;
		this.authStore.dispatch(UserActions.setProfile({ payload: profile }));
	}

	onDelete() {
		this.authStore.dispatch(UserActions.deleteAccount());
	}
}
