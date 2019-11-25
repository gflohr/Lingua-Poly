import { Component, OnInit } from '@angular/core';
import { UsersService } from 'src/app/core/openapi/lingua-poly';
import { Store } from '@ngrx/store';
import { AppState } from 'src/app/app.interfaces';
import { Observable } from 'rxjs';

@Component({
	selector: 'app-header',
	templateUrl: './header.component.html',
	styleUrls: ['./header.component.css']
})
export class HeaderComponent implements OnInit {
	username$: Observable<String> = this.store.select(state => state.user.username);

	constructor(
		private usersService: UsersService,
		private store: Store<AppState>
	) { }

	ngOnInit() {
		this.usersService.profileGet().subscribe(
			(user) => {
				console.log('user');
			}
		);
	}

}
