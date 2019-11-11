import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';

@Component({
	selector: 'app-registration-confirmed',
	templateUrl: './registration-confirmed.component.html',
	styleUrls: ['./registration-confirmed.component.css']
})
export class RegistrationConfirmedComponent implements OnInit {

	constructor(private route: ActivatedRoute) { }

	ngOnInit() {
		const token = this.route.snapshot.paramMap.get('token');
		console.log('token: ' + token);
	}

}
