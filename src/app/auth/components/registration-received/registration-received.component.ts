import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';

@Component({
	selector: 'app-registration-received',
	templateUrl: './registration-received.component.html',
	styleUrls: ['./registration-received.component.css']
})
export class RegistrationReceivedComponent implements OnInit {
	email: string;
	constructor(private route: ActivatedRoute) {}

	ngOnInit() {
		this.email = this.route.snapshot.paramMap.get('email');
	}

}
