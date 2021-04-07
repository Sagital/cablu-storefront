// react
import {
    Fragment,
    Ref,
    ReactNode,
    useCallback,
    useEffect,
    useMemo,
    useRef,
    useState,
} from 'react';

export interface CollapseRenderFnData<T extends HTMLElement, P extends HTMLElement> {
    toggle: () => void;
    setItemRef: Ref<T>;
    setContentRef: Ref<P>;
}

export type CollapseRenderFn<T extends HTMLElement, P extends HTMLElement>
    = (data: CollapseRenderFnData<T, P>) => ReactNode;

export interface CollapseProps<T extends HTMLElement, P extends HTMLElement> {
    toggleClass: string;
    render: CollapseRenderFn<T, P>;
    open?: boolean;
}

function Collapse<T extends HTMLElement, P extends HTMLElement>(props: CollapseProps<T, P>) {
    const { toggleClass, render, open } = props;
    const [init, setInit] = useState(false);
    const itemRef = useRef<T>(null);
    const contentRef = useRef<P>(null);

    const expand = useCallback((immediate = false) => {
        if (!itemRef.current || !contentRef.current) {
            return;
        }

        if (immediate) {
            itemRef.current.classList.add(toggleClass);
            contentRef.current.style.height = '';
        } else {
            const startHeight = contentRef.current.getBoundingClientRect().height;

            itemRef.current.classList.add(toggleClass);

            const endHeight = contentRef.current.getBoundingClientRect().height;

            contentRef.current.style.height = `${startHeight}px`;
            contentRef.current.getBoundingClientRect(); // force reflow
            contentRef.current.style.height = `${endHeight}px`;
        }
    }, [toggleClass, itemRef, contentRef]);

    const collapse = useCallback((immediate = false) => {
        if (!itemRef.current || !contentRef.current) {
            return;
        }

        if (immediate) {
            itemRef.current.classList.remove(toggleClass);
            contentRef.current.style.height = '';
        } else {
            const startHeight = contentRef.current.getBoundingClientRect().height;

            contentRef.current.style.height = `${startHeight}px`;
            itemRef.current.classList.remove(toggleClass);

            contentRef.current.getBoundingClientRect(); // force reflow
            contentRef.current.style.height = '';
        }
    }, [toggleClass, itemRef, contentRef]);

    const handleToggle = useCallback(() => {
        if (!itemRef.current || !contentRef.current) {
            return;
        }

        if (itemRef.current.classList.contains(toggleClass)) {
            collapse();
        } else {
            expand();
        }
    }, [toggleClass, itemRef, contentRef]);

    useEffect(() => {
        if (typeof open === 'boolean') {
            if (open) {
                expand(!init);
            } else {
                collapse(!init);
            }
        }

        setInit(true);
    }, [open, init]);

    useEffect(() => {
        if (!contentRef.current) {
            return () => {};
        }

        const handleTransitionEnd = (event: TransitionEvent) => {
            if (contentRef.current && event.propertyName === 'height') {
                contentRef.current.style.height = '';
            }
        };

        contentRef.current.addEventListener('transitionend', handleTransitionEnd);

        return () => {
            if (!contentRef.current) {
                return;
            }

            contentRef.current.removeEventListener('transitionend', handleTransitionEnd);
        };
    }, [contentRef]);

    if (render) {
        return (
            <Fragment>
                {useMemo(() => render({
                    toggle: handleToggle,
                    setItemRef: itemRef,
                    setContentRef: contentRef,
                }), [render, handleToggle, itemRef, contentRef])}
            </Fragment>
        );
    }

    return null;
}

export default Collapse;
