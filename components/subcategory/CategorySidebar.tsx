// react
import { PropsWithChildren, useEffect, useRef } from 'react'

// third-party
import classNames from 'classnames'

// application
import Cross20Svg from '../../svg/cross-20.svg'

export type CategorySidebarOffcanvas = 'always' | 'mobile'

export interface CategorySidebarProps extends PropsWithChildren<{}> {
  open: boolean
  closeFn?: () => void
  offcanvas?: CategorySidebarOffcanvas
}

function CategorySidebar(props: CategorySidebarProps) {
  const { children, open, closeFn, offcanvas = 'mobile' } = props

  const classes = classNames('block block-sidebar', {
    'block-sidebar--open': open,
    'block-sidebar--offcanvas--always': offcanvas === 'always',
    'block-sidebar--offcanvas--mobile': offcanvas === 'mobile',
  })

  const backdropRef = useRef<HTMLDivElement>(null)
  const bodyRef = useRef<HTMLDivElement>(null)

  useEffect(() => {
    const media = matchMedia('(max-width: 991px)')
    let changedByMedia = false

    const onChange = () => {
      if (offcanvas === 'mobile') {
        if (open && !media.matches && closeFn) {
          closeFn()
        }
        // this is necessary to avoid the transition hiding the sidebar
        if (!open && media.matches && changedByMedia && backdropRef.current && bodyRef.current) {
          const backdrop = backdropRef.current
          const body = bodyRef.current

          backdrop.style.transition = 'none'
          body.style.transition = 'none'

          backdrop.getBoundingClientRect() // force reflow

          backdrop.style.transition = ''
          body.style.transition = ''
        }
      }
    }

    if (media.addEventListener) {
      media.addEventListener('change', onChange)
    } else {
      media.addListener(onChange)
    }

    onChange()

    changedByMedia = true

    return () => {
      if (media.removeEventListener) {
        media.removeEventListener('change', onChange)
      } else {
        media.removeListener(onChange)
      }
    }
  }, [offcanvas, open, closeFn])

  useEffect(() => {
    if (open) {
      const width = document.body.clientWidth

      document.body.style.overflow = 'hidden'
      document.body.style.paddingRight = `${document.body.clientWidth - width}px`
    } else {
      document.body.style.overflow = ''
      document.body.style.paddingRight = ''
    }
  }, [open])

  return (
    <div className={classes}>
      {/* eslint-disable-next-line max-len */}
      {/* eslint-disable-next-line jsx-a11y/click-events-have-key-events, jsx-a11y/no-static-element-interactions */}
      <div className="block-sidebar__backdrop" ref={backdropRef} onClick={closeFn} />
      <div className="block-sidebar__body" ref={bodyRef}>
        <div className="block-sidebar__header">
          <div className="block-sidebar__title">Filters</div>
          <button className="block-sidebar__close" type="button" onClick={closeFn}>
            <Cross20Svg />
          </button>
        </div>
        {children}
      </div>
    </div>
  )
}

export default CategorySidebar
