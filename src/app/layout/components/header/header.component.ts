import { Component, OnInit } from '@angular/core';
import { Store, select } from '@ngrx/store';
import { Observable } from 'rxjs';
import * as fromAuth from 'src/app/auth/reducers';

@Component({
	selector: 'app-header',
	templateUrl: './header.component.html',
	styleUrls: ['./header.component.css']
})
export class HeaderComponent implements OnInit {
	username$: Observable<String>;
	loggedIn$: Observable<boolean>;

	constructor(
		private authStore: Store<fromAuth.State>
	) {
		this.username$ = this.authStore.pipe(select(fromAuth.selectDisplayName));
		this.loggedIn$ = this.authStore.pipe(select(fromAuth.selectLoggedIn));
	}

	ngOnInit() {
	}

}
