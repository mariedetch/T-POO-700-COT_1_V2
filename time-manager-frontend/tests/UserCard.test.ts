import { mount } from '@vue/test-utils';
import { describe, it, expect, vi, beforeEach } from 'vitest';
import { nextTick } from 'vue';
import UserCard from '../src/components/features/users/User.vue';
import { useUsersStore } from '../src/stores/users'; 

vi.mock('@/stores/users', () => ({
  useUsersStore: vi.fn(),
}));

describe('UserCard.vue', () => {
    let mockUserStore: any;

    beforeEach(() => {
        mockUserStore = {
            currentUser: { username: 'John Doe', email: 'john.doe@example.com' },
            userId: 1,
            getUser: vi.fn().mockResolvedValue({ username: 'John Doe', email: 'john.doe@example.com' }),
        };
        (useUsersStore as any).mockReturnValue(mockUserStore);
    });

    // premier test
    it("affiche le username de l'utilisateur", async () => {
        const wrapper = mount(UserCard);

        await nextTick();

        expect(wrapper.find('h6').text()).toBe('John Doe');
    });

    // second test
    it("affiche l'email de l'utilisateur", async () => {
        const wrapper = mount(UserCard);

        await nextTick();

        expect(wrapper.find('small').text()).toBe('john.doe@example.com');
    });

    // troisième test
    it('appelle getUser lors du montage', async () => {
        mount(UserCard);

        await nextTick();

        expect(mockUserStore.getUser).toHaveBeenCalledWith(1);
    });
});