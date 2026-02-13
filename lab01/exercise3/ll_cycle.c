#include <stddef.h>
#include "ll_cycle.h"

int ll_has_cycle(node *head) {
    /* TODO: Implement ll_has_cycle */
    if(head==NULL || head->next==NULL)
    {
        return 0;
    }
    node* fast_ptr=head->next->next;
    node* slow_ptr=head;
    while(fast_ptr!=NULL)
    {
        if(fast_ptr==slow_ptr)
        {
            return 1;
        }
        else if(fast_ptr->next==NULL)
        {
            break;
        }
        else{
            fast_ptr=fast_ptr->next->next;
            slow_ptr=slow_ptr->next;
        }
    }
    return 0; 
}
