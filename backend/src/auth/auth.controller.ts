import { Controller, Post, Body } from '@nestjs/common';
import { AuthService, RegisterCustomerDto, RegisterWorkerDto, RegisterBusinessDto } from './auth.service';

@Controller('auth')
export class AuthController {
  constructor(private authService: AuthService) {}

  @Post('register/customer')
  async registerCustomer(@Body() registerDto: RegisterCustomerDto) {
    return this.authService.registerCustomer(registerDto);
  }

  @Post('register/worker')
  async registerWorker(@Body() registerDto: RegisterWorkerDto) {
    return this.authService.registerWorker(registerDto);
  }

  @Post('register/business')
  async registerBusiness(@Body() registerDto: RegisterBusinessDto) {
    return this.authService.registerBusiness(registerDto);
  }

  @Post('login')
  async login(@Body('idToken') idToken: string) {
    const user = await this.authService.validateFirebaseToken(idToken);
    return this.authService.login(user);
  }

  @Post('logout')
  async logout() {
    // In a real implementation, you might want to blacklist the token
    return { message: 'Logged out successfully' };
  }
}