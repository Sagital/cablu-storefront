import { PropsWithChildren, HTMLAttributes, AnchorHTMLAttributes } from 'react'

// third-party
import Link, { LinkProps } from 'next/link'
import { ILinkProps } from '../../interfaces/menus/link-props'

// application

export type LinkType = string | ILinkProps

export interface AppLinkProps extends PropsWithChildren<HTMLAttributes<HTMLElement>> {
  href?: LinkType
  target?: AnchorHTMLAttributes<HTMLAnchorElement>['target']
}

function isLink(href: LinkType | undefined): href is LinkType {
  return href !== undefined
}
function isSimpleLink(href: LinkType | undefined): href is string {
  return href !== undefined && typeof href === 'string'
}
function isExternal(href: string): boolean {
  return /^(https?:)?\/\//.test(href)
}

function AppLink(props: AppLinkProps) {
  const { href: hrefProp, children, ...anchorProps } = props
  const href = hrefProp || '/'

  let link

  if (!isLink(href) || (isSimpleLink(href) && isExternal(href))) {
    link = (
      <a href={href} {...anchorProps}>
        {children}
      </a>
    )
  } else {
    const linkProps: LinkProps = typeof href === 'string' ? { href } : href

    link = (
      <Link {...linkProps}>
        <a {...anchorProps}>{children}</a>
      </Link>
    )
  }

  return link
}

export default AppLink
