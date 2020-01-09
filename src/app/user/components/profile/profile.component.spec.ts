import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { ProfileComponent } from './profile.component';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { ConnectFormDirective } from 'src/app/core/directives/connect-form.directive';
import { HttpClientModule } from '@angular/common/http';
import { StoreModule } from '@ngrx/store';
import { authReducers, authFeatureKey } from '../../../auth/reducers/';

describe('ProfileComponent', () => {
	let component: ProfileComponent;
	let fixture: ComponentFixture<ProfileComponent>;

	beforeEach(async(() => {
		TestBed.configureTestingModule({
			imports: [
				FormsModule,
				ReactiveFormsModule,
				HttpClientModule,
				StoreModule.forRoot({ [authFeatureKey]: authReducers }, {
					runtimeChecks: {
						strictActionImmutability: true,
						strictActionSerializability: true,
						strictStateImmutability: true,
						strictStateSerializability: true
					}
				})
			],
			declarations: [
				ProfileComponent,
				ConnectFormDirective
			]
		})
		.compileComponents();
	}));

	beforeEach(() => {
		fixture = TestBed.createComponent(ProfileComponent);
		component = fixture.componentInstance;
		fixture.detectChanges();
	});

	afterEach(() => { fixture.destroy(); });

	it('should create', () => {
		expect(component).toBeTruthy();
	});
});
