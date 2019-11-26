import { Component, OnInit } from '@angular/core';
import { UsersService } from 'src/app/core/openapi/lingua-poly';
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

	constructor(
		private store: Store<fromAuth.State>
	) {
		this.username$ = this.store.pipe(select(fromAuth.displayName));
	}

	ngOnInit() {
	}

}
