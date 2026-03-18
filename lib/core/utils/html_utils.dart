class HtmlUtils {
  const HtmlUtils._();

  static String stripHtml(String html) {
    final withoutTags = html
        .replaceAll(RegExp(r'<style[^>]*>[\s\S]*?</style>', caseSensitive: false), ' ')
        .replaceAll(RegExp(r'<[^>]+>'), ' ')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>');
    return withoutTags.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  static String preview(String html, {int maxLength = 150}) {
    final text = stripHtml(html);
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength).trim()}…';
  }

  static String sanitize(String html) {
    return html
        .replaceAll(RegExp(r'<script[^>]*>[\s\S]*?</script>', caseSensitive: false), '')
        .trim();
  }
}
