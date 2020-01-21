export * from './core.service';
import { CoreService } from './core.service';
export * from './oauth.service';
import { OauthService } from './oauth.service';
export * from './users.service';
import { UsersService } from './users.service';
export const APIS = [CoreService, OauthService, UsersService];
