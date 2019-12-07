import { Component, OnInit } from '@angular/core';
import { FormBuilder } from '@angular/forms';

@Component({
	selector: 'app-profile',
	templateUrl: './profile.component.html',
	styleUrls: ['./profile.component.css']
})
export class ProfileComponent implements OnInit {
	constructor(
		private fb: FormBuilder
	) {
	}

	profileForm = this.fb.group({
		username: [''],
		homepage: [''],
		description: ['']
	});

	ngOnInit() {
	}
}
