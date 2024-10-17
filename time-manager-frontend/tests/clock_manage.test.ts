import { mount } from '@vue/test-utils';
import { describe, it, expect, vi, beforeEach } from 'vitest';
import ClockComponent from '../src/components/features/clocks/ClockManager.vue';
import { useClocksStore } from '../src/stores/clocks';
import { ToastrService } from '../src/utils/toastr';

// Mock du store
vi.mock('@/stores/clocks', () => ({
  useClocksStore: vi.fn(),
}));

// Mock de ToastrService
vi.mock('@/utils/toastr', () => ({
  ToastrService: {
    success: vi.fn(),
    error: vi.fn(),
  },
}));

describe('ClockComponent.vue', () => {
  let mockClockStore;

  beforeEach(() => {
    // Mock du store pour simuler les valeurs actuelles
    mockClockStore = {
      startDateTime: null,
      clockIn: false,
      clock: vi.fn().mockResolvedValue({}),
      getLatestClock: vi.fn().mockResolvedValue({}),
    };
    (useClocksStore as any).mockReturnValue(mockClockStore);
  });

  it('affiche le message par défaut quand l\'utilisateur n\'a pas encore clocké', async () => {
    const wrapper = mount(ClockComponent);

    // Attendre que le composant soit monté
    await wrapper.vm.$nextTick();

    // Vérifier que le message par défaut est affiché
    expect(wrapper.find('label').text()).toBe('Marquez votre arrivée');
  });

  it('affiche le message avec le temps écoulé après clock', async () => {
    mockClockStore.startDateTime = new Date().toISOString();
    mockClockStore.clockIn = true;

    const wrapper = mount(ClockComponent);

    // Attendre que le composant soit monté
    await wrapper.vm.$nextTick();

    // Mettre à jour le temps écoulé manuellement
    await wrapper.vm.updateElapsedTime();
    expect(wrapper.find('label').text()).toContain('Démarrer il y a');
  });

  it('appelle clock lorsqu\'on change l\'état de la case à cocher', async () => {
    const wrapper = mount(ClockComponent);

    // Simule le changement d'état de la case à cocher
    await wrapper.find('input[type="checkbox"]').setValue(true);

    // Vérifier que la méthode clock a été appelée
    expect(mockClockStore.clock).toHaveBeenCalled();
    expect(ToastrService.success).toHaveBeenCalledWith('Clock effectué avec succès');
  });

  it('affiche une erreur si clock échoue', async () => {
    mockClockStore.clock.mockRejectedValue(new Error('Erreur de clock'));

    const wrapper = mount(ClockComponent);

    // Simule le changement d'état de la case à cocher
    await wrapper.find('input[type="checkbox"]').setValue(true);

    // Vérifier que la méthode error du ToastrService a été appelée
    expect(ToastrService.error).toHaveBeenCalledWith('Echec lors du clock! veuillez reéssayer ultérieurement');
  });
});
