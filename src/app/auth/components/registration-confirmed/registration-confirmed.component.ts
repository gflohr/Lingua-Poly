import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { UsersService, Token } from 'src/app/core/openapi/lingua-poly';
import * as fromAuth from '../../../auth/reducers';
import { Store } from '@ngrx/store';
import { AuthApiActions } from '../../actions';

@Component({
	selector: 'app-registration-confirmed',
	templateUrl: './registration-confirmed.component.html',
	styleUrls: ['./registration-confirmed.component.css']
})
export class RegistrationConfirmedComponent implements OnInit {
	pending = true;
	error: boolean;
	success: boolean;

	constructor(
		private route: ActivatedRoute,
		private usersService: UsersService,
		private authStore: Store<fromAuth.State>,
	) { }

	ngOnInit() {
		const token = {
			token: this.route.snapshot.paramMap.get('token')
		} as Token;

		this.usersService.register(token).subscribe(
			user => {
				this.pending = false;
				this.success = true;
				this.authStore.dispatch(AuthApiActions.loginSuccess({ user }));
			},
			() => {
				this.pending = false;
				this.error = true;
			}
		);
	}
}
