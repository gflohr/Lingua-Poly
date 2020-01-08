import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { LoginComponent } from './login.component';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { TranslateModule } from '@ngx-translate/core';
import { provideMockStore, MockStore } from '@ngrx/store/testing';
import { Store } from '@ngrx/store';

describe('LoginComponent', () => {
	let component: LoginComponent;
	let fixture: ComponentFixture<LoginComponent>;
	let store: MockStore<{}>;
	const initialState = {};

	beforeEach(async(() => {
		TestBed.configureTestingModule({
			imports: [
				FormsModule,
				ReactiveFormsModule,
				TranslateModule.forRoot()
			],
			declarations: [ LoginComponent ],
			providers: [
				provideMockStore({ initialState })
			]
		})
		.compileComponents();

		store = TestBed.get<Store<any>>(Store);
	}));

	beforeEach(() => {
		fixture = TestBed.createComponent(LoginComponent);
		component = fixture.componentInstance;
		fixture.detectChanges();
	});

	it('should create', () => {
		expect(component).toBeTruthy();
	});
});
