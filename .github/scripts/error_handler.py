"""
간단한 에러 핸들링 유틸리티 모듈

print 문을 사용하면서도 체계적인 에러 처리를 제공합니다.
기존 코드를 최소한으로 수정하면서 에러 로깅을 개선할 수 있습니다.
"""

import sys
import traceback
from datetime import datetime
from typing import Optional, Any


def log_error(message: str, error: Optional[Exception] = None, context: Optional[dict] = None):
    """
    에러 메시지를 표준화된 형식으로 출력
    
    Args:
        message: 에러 메시지
        error: 예외 객체 (선택사항)
        context: 추가 컨텍스트 정보 (선택사항)
    """
    timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    
    # 기본 에러 메시지 출력
    print(f"[ERROR] {timestamp} - {message}", file=sys.stderr)
    
    # 예외 정보가 있으면 출력
    if error:
        print(f"[ERROR] Exception: {type(error).__name__}: {str(error)}", file=sys.stderr)
    
    # 컨텍스트 정보가 있으면 출력
    if context:
        context_str = ", ".join(f"{k}={v}" for k, v in context.items())
        print(f"[ERROR] Context: {context_str}", file=sys.stderr)


def log_warning(message: str, context: Optional[dict] = None):
    """
    경고 메시지를 표준화된 형식으로 출력
    
    Args:
        message: 경고 메시지
        context: 추가 컨텍스트 정보 (선택사항)
    """
    timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    
    print(f"[WARNING] {timestamp} - {message}", file=sys.stderr)
    
    if context:
        context_str = ", ".join(f"{k}={v}" for k, v in context.items())
        print(f"[WARNING] Context: {context_str}", file=sys.stderr)


def log_info(message: str, context: Optional[dict] = None):
    """
    정보 메시지를 표준화된 형식으로 출력
    
    Args:
        message: 정보 메시지
        context: 추가 컨텍스트 정보 (선택사항)
    """
    timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    
    print(f"[INFO] {timestamp} - {message}")
    
    if context:
        context_str = ", ".join(f"{k}={v}" for k, v in context.items())
        print(f"[INFO] Context: {context_str}")


def log_debug(message: str, context: Optional[dict] = None, enabled: bool = False):
    """
    디버그 메시지를 표준화된 형식으로 출력 (선택적)
    
    Args:
        message: 디버그 메시지
        context: 추가 컨텍스트 정보 (선택사항)
        enabled: 디버그 모드 활성화 여부
    """
    if not enabled:
        return
        
    timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    
    print(f"[DEBUG] {timestamp} - {message}")
    
    if context:
        context_str = ", ".join(f"{k}={v}" for k, v in context.items())
        print(f"[DEBUG] Context: {context_str}")


def handle_subprocess_error(e: Exception, command: str, context: Optional[dict] = None):
    """
    subprocess 관련 에러를 처리하는 헬퍼 함수
    
    Args:
        e: subprocess.CalledProcessError 또는 기타 예외
        command: 실행한 명령어
        context: 추가 컨텍스트 정보
    """
    error_context = {"command": command}
    if context:
        error_context.update(context)
    
    if hasattr(e, 'stderr') and e.stderr:
        error_context["stderr"] = e.stderr.strip()
    if hasattr(e, 'returncode'):
        error_context["return_code"] = e.returncode
    
    log_error("Subprocess command failed", e, error_context)


def handle_api_error(e: Exception, url: str, context: Optional[dict] = None):
    """
    API 호출 관련 에러를 처리하는 헬퍼 함수
    
    Args:
        e: requests.exceptions.RequestException 또는 기타 예외
        url: API URL
        context: 추가 컨텍스트 정보
    """
    error_context = {"url": url}
    if context:
        error_context.update(context)
    
    if hasattr(e, 'response') and e.response is not None:
        error_context["status_code"] = e.response.status_code
        try:
            error_context["response_text"] = e.response.text[:200]  # 처음 200자만
        except:
            pass
    
    log_error("API request failed", e, error_context)


def safe_exit(exit_code: int = 1, message: Optional[str] = None):
    """
    안전한 프로그램 종료
    
    Args:
        exit_code: 종료 코드
        message: 종료 메시지 (선택사항)
    """
    if message:
        log_error(f"Program terminating: {message}")
    
    sys.exit(exit_code)


class ErrorContext:
    """
    간단한 컨텍스트 매니저 - 작업 단위별 에러 처리
    """
    
    def __init__(self, operation: str, **kwargs):
        self.operation = operation
        self.context = kwargs
        self.start_time = None
    
    def __enter__(self):
        self.start_time = datetime.now()
        log_info(f"Starting {self.operation}", self.context)
        return self
    
    def __exit__(self, exc_type, exc_val, exc_tb):
        duration = (datetime.now() - self.start_time).total_seconds()
        
        if exc_type is None:
            log_info(f"Completed {self.operation} successfully", 
                    {**self.context, "duration_seconds": f"{duration:.2f}"})
        else:
            log_error(f"Failed {self.operation}", exc_val, 
                     {**self.context, "duration_seconds": f"{duration:.2f}"})
        
        return False  # Re-raise exception


# 편의를 위한 짧은 함수 이름들
def error(message: str, exception: Optional[Exception] = None, **context):
    """log_error의 짧은 버전"""
    log_error(message, exception, context if context else None)


def warn(message: str, **context):
    """log_warning의 짧은 버전"""
    log_warning(message, context if context else None)


def info(message: str, **context):
    """log_info의 짧은 버전"""
    log_info(message, context if context else None)


def debug(message: str, enabled: bool = False, **context):
    """log_debug의 짧은 버전"""
    log_debug(message, context if context else None, enabled)