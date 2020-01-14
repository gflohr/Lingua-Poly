import { TestBed, async } from '@angular/core/testing';
import { OAuth2Service } from './oauth2.service';

import { SocialLoginModule, AuthServiceConfig, FacebookLoginProvider } from 'angularx-social-login';
import { StoreModule } from '@ngrx/store';
import { authFeatureKey, authReducers } from '../reducers';

const config = new AuthServiceConfig([
	{
		id: FacebookLoginProvider.PROVIDER_ID,
		provider: new FacebookLoginProvider('invalid')
	}
]);

function provideConfig() {
	return config;
}

describe('OAuth2Service', () => {
	beforeEach(async(() => {
		TestBed.configureTestingModule({
			imports: [
				SocialLoginModule,
				StoreModule.forRoot({ [authFeatureKey]: authReducers }, {
					runtimeChecks: {
						strictActionImmutability: true,
						strictActionSerializability: true,
						strictStateImmutability: true,
						strictStateSerializability: true
					}
				})
			],
			declarations: [],
			providers: [
				{
					provide: AuthServiceConfig,
					useFactory: provideConfig
				}
			]
		});
	}));

	it('should be created', () => {
		const service: OAuth2Service = TestBed.get(OAuth2Service);
		expect(service).toBeTruthy();
	});
});
