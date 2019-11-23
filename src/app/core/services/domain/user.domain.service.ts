import { Injectable } from "@angular/core";
import { UsersService } from "../../openapi/lingua-poly";

@Injectable()
export class UserDomainService {
	constructor(
		private usersService: UsersService
	) { }

	getProfile() {
		return this.usersService.profileGet().pipe(
			profile => { return profile; }
		);
	}
}
