import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { HeaderComponent } from './header.component';
import { TranslateModule } from '@ngx-translate/core';
import { provideMockStore } from '@ngrx/store/testing';
import { authFeatureKey } from '../../../auth/reducers';

describe('HeaderComponent', () => {
	let component: HeaderComponent;
	let fixture: ComponentFixture<HeaderComponent>;
	const initialState = { [authFeatureKey]: {}};

	beforeEach(async(() => {
		TestBed.configureTestingModule({
			imports: [ TranslateModule.forRoot() ],
			declarations: [ HeaderComponent ],
			providers: [
				provideMockStore({ initialState })
			]
		})
		.compileComponents();
	}));

	beforeEach(() => {
		fixture = TestBed.createComponent(HeaderComponent);
		component = fixture.componentInstance;
		fixture.detectChanges();
	});

	afterEach(() => { fixture.destroy(); });

	it('should create', () => {
		expect(component).toBeTruthy();
	});
});
