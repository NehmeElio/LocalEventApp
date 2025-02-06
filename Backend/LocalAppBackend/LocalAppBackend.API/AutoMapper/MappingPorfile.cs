using AutoMapper;
using LocalAppBackend.API.DTO;
using LocalAppBackend.Domain.Models;

namespace LocalAppBackend.API.AutoMapper;

using AutoMapper;

public class MappingProfile : Profile
{
    public MappingProfile()
    {
        CreateMap<Account, UserDto>();
        CreateMap<Event, EventDto>()
            .ForMember(dest => dest.CategoryId, opt => opt.MapFrom(src =>
                src.CategoryEvents.Select(ce => ce.CategoryId).ToList())) // Mapping CategoryId
            .ForMember(dest => dest.GalleryImages, opt => opt.MapFrom(src =>
                src.ImageGalleries.Select(g => new ImageGalleryDTO
                {
                    ImageGalleryId = g.ImageGalleryId,
                    Image = g.Image
                }).ToList())); // Mapping GalleryImages
        CreateMap<Account, GuestDto>();
    }

}
