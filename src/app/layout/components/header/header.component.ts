import { Component, OnInit } from '@angular/core';
import { UsersService } from 'src/app/core/openapi/lingua-poly';

@Component({
	selector: 'app-header',
	templateUrl: './header.component.html',
	styleUrls: ['./header.component.css']
})
export class HeaderComponent implements OnInit {

	constructor(
		private usersService: UsersService
	) { }

	ngOnInit() {
		this.usersService.profileGet().subscribe(
			(user) => {
				console.log('user');
			}
		);
	}

}
