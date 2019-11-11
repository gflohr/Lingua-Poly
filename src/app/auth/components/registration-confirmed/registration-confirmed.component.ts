import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { UsersService, Token } from 'src/app/core/openapi/lingua-poly';
import { catchError } from 'rxjs/operators';
import { of } from 'rxjs';

@Component({
	selector: 'app-registration-confirmed',
	templateUrl: './registration-confirmed.component.html',
	styleUrls: ['./registration-confirmed.component.css']
})
export class RegistrationConfirmedComponent implements OnInit {
	pending: boolean = true;
	error: boolean;
	success: boolean;

	constructor(
		private route: ActivatedRoute,
		private usersService: UsersService
	) { }

	ngOnInit() {
		const token = {
			token: this.route.snapshot.paramMap.get('token')
		} as Token;

		this.usersService.register(token)
		.pipe(
			catchError(err => of([err]))
		)
		.subscribe(
			err => {
				this.pending = false;
				this.error = true;
				console.log(err);
			},
			data => {
				this.pending = false;
				this.success = true;
				console.log(data);
			}
		);
		console.log('token: ', token);
	}

}
