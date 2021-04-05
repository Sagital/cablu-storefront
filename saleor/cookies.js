const CART_TOKEN_COOKIE = 'cart_token'

export const readCartTokenCookie = req => {
  return req.cookies[CART_TOKEN_COOKIE]
}

export const deleteCartTokenCookie = res => {
  res.clearCookie(CART_TOKEN_COOKIE)
}
