class HttpException implements Exception {
  HttpException(this.message);

  final String message;

  @override
  String toString() {
    return message;
  }
}

class UnauthorizedException extends HttpException {
  UnauthorizedException(super.message);
}

class BadRequestException extends HttpException {
  BadRequestException(super.message);
}

class NotFoundException extends HttpException {
  NotFoundException(super.message);
}

class ServerErrorException extends HttpException {
  ServerErrorException(super.message);
}

class PaymentRequiredException extends HttpException {
  PaymentRequiredException(super.message);
}

class ForbiddenException extends HttpException {
  ForbiddenException(super.message);
}

class UnProcessableEntityException extends HttpException {
  UnProcessableEntityException(super.message);
}

class ApiException extends HttpException {
  ApiException(super.message);
}

class DefaultException extends ApiException {
  DefaultException(super.message);
}
